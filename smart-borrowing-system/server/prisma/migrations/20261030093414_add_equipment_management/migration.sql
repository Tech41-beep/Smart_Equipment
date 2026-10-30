/*
  Warnings:

  - You are about to drop the column `borrowerId` on the `Borrowing` table. All the data in the column will be lost.
  - You are about to drop the column `checkedOutAt` on the `Borrowing` table. All the data in the column will be lost.
  - You are about to drop the column `notes` on the `Borrowing` table. All the data in the column will be lost.
  - You are about to drop the column `requestedAt` on the `Borrowing` table. All the data in the column will be lost.
  - The `status` column on the `Borrowing` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `assetTag` on the `Equipment` table. All the data in the column will be lost.
  - You are about to drop the column `availableQuantity` on the `Equipment` table. All the data in the column will be lost.
  - You are about to drop the column `qrCode` on the `Equipment` table. All the data in the column will be lost.
  - You are about to drop the column `totalQuantity` on the `Equipment` table. All the data in the column will be lost.
  - The `role` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the `BorrowingItem` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[requestId]` on the table `Borrowing` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `issuedBy` to the `Borrowing` table without a default value. This is not possible if the table is not empty.
  - Added the required column `requestId` to the `Borrowing` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Category` table without a default value. This is not possible if the table is not empty.
  - Made the column `categoryId` on table `Equipment` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('STUDENT', 'STAFF', 'ADMIN', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "AssetCondition" AS ENUM ('NEW', 'EXCELLENT', 'GOOD', 'FAIR', 'DAMAGED');

-- CreateEnum
CREATE TYPE "AssetStatus" AS ENUM ('AVAILABLE', 'RESERVED', 'BORROWED', 'MAINTENANCE', 'RETIRED', 'LOST');

-- CreateEnum
CREATE TYPE "BorrowRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "BorrowingStatus" AS ENUM ('ACTIVE', 'OVERDUE', 'RETURNED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('BORROW_REQUEST', 'REQUEST_APPROVED', 'REQUEST_REJECTED', 'BORROW_REMINDER', 'OVERDUE', 'RETURN_CONFIRMATION');

-- DropForeignKey
ALTER TABLE "Borrowing" DROP CONSTRAINT "Borrowing_borrowerId_fkey";

-- DropForeignKey
ALTER TABLE "BorrowingItem" DROP CONSTRAINT "BorrowingItem_borrowingId_fkey";

-- DropForeignKey
ALTER TABLE "BorrowingItem" DROP CONSTRAINT "BorrowingItem_equipmentId_fkey";

-- DropForeignKey
ALTER TABLE "Equipment" DROP CONSTRAINT "Equipment_categoryId_fkey";

-- DropIndex
DROP INDEX "Equipment_assetTag_key";

-- DropIndex
DROP INDEX "Equipment_qrCode_key";

-- AlterTable
ALTER TABLE "Borrowing" DROP COLUMN "borrowerId",
DROP COLUMN "checkedOutAt",
DROP COLUMN "notes",
DROP COLUMN "requestedAt",
ADD COLUMN     "borrowedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "issuedBy" TEXT NOT NULL,
ADD COLUMN     "requestId" TEXT NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" "BorrowingStatus" NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE "Category" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Equipment" DROP COLUMN "assetTag",
DROP COLUMN "availableQuantity",
DROP COLUMN "qrCode",
DROP COLUMN "totalQuantity",
ADD COLUMN     "brand" TEXT,
ADD COLUMN     "imageUrl" TEXT,
ADD COLUMN     "model" TEXT,
ALTER COLUMN "categoryId" SET NOT NULL;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "phone" TEXT,
DROP COLUMN "role",
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'STUDENT';

-- DropTable
DROP TABLE "BorrowingItem";

-- CreateTable
CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "equipmentId" TEXT NOT NULL,
    "assetCode" TEXT NOT NULL,
    "qrToken" TEXT NOT NULL,
    "serialNumber" TEXT,
    "condition" "AssetCondition" NOT NULL DEFAULT 'GOOD',
    "status" "AssetStatus" NOT NULL DEFAULT 'AVAILABLE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BorrowRequest" (
    "id" TEXT NOT NULL,
    "borrowerId" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "requestedStart" TIMESTAMP(3) NOT NULL,
    "requestedEnd" TIMESTAMP(3) NOT NULL,
    "purpose" TEXT NOT NULL,
    "status" "BorrowRequestStatus" NOT NULL DEFAULT 'PENDING',
    "rejectionReason" TEXT,
    "reviewedBy" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BorrowRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReturnRecord" (
    "id" TEXT NOT NULL,
    "borrowingId" TEXT NOT NULL,
    "receivedBy" TEXT NOT NULL,
    "condition" "AssetCondition" NOT NULL,
    "notes" TEXT,
    "returnedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReturnRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "details" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Asset_assetCode_key" ON "Asset"("assetCode");

-- CreateIndex
CREATE UNIQUE INDEX "Asset_qrToken_key" ON "Asset"("qrToken");

-- CreateIndex
CREATE UNIQUE INDEX "Asset_serialNumber_key" ON "Asset"("serialNumber");

-- CreateIndex
CREATE INDEX "Asset_equipmentId_idx" ON "Asset"("equipmentId");

-- CreateIndex
CREATE INDEX "Asset_status_idx" ON "Asset"("status");

-- CreateIndex
CREATE INDEX "Asset_condition_idx" ON "Asset"("condition");

-- CreateIndex
CREATE INDEX "BorrowRequest_borrowerId_idx" ON "BorrowRequest"("borrowerId");

-- CreateIndex
CREATE INDEX "BorrowRequest_assetId_idx" ON "BorrowRequest"("assetId");

-- CreateIndex
CREATE INDEX "BorrowRequest_status_idx" ON "BorrowRequest"("status");

-- CreateIndex
CREATE INDEX "BorrowRequest_requestedStart_requestedEnd_idx" ON "BorrowRequest"("requestedStart", "requestedEnd");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnRecord_borrowingId_key" ON "ReturnRecord"("borrowingId");

-- CreateIndex
CREATE INDEX "ReturnRecord_receivedBy_idx" ON "ReturnRecord"("receivedBy");

-- CreateIndex
CREATE INDEX "ReturnRecord_returnedAt_idx" ON "ReturnRecord"("returnedAt");

-- CreateIndex
CREATE INDEX "Notification_userId_idx" ON "Notification"("userId");

-- CreateIndex
CREATE INDEX "Notification_userId_isRead_idx" ON "Notification"("userId", "isRead");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "Notification"("createdAt");

-- CreateIndex
CREATE INDEX "AuditLog_userId_idx" ON "AuditLog"("userId");

-- CreateIndex
CREATE INDEX "AuditLog_entityType_entityId_idx" ON "AuditLog"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "Borrowing_requestId_key" ON "Borrowing"("requestId");

-- CreateIndex
CREATE INDEX "Borrowing_status_idx" ON "Borrowing"("status");

-- CreateIndex
CREATE INDEX "Borrowing_dueAt_idx" ON "Borrowing"("dueAt");

-- CreateIndex
CREATE INDEX "Borrowing_issuedBy_idx" ON "Borrowing"("issuedBy");

-- CreateIndex
CREATE INDEX "Equipment_categoryId_idx" ON "Equipment"("categoryId");

-- CreateIndex
CREATE INDEX "Equipment_name_idx" ON "Equipment"("name");

-- CreateIndex
CREATE INDEX "User_role_idx" ON "User"("role");

-- CreateIndex
CREATE INDEX "User_isActive_idx" ON "User"("isActive");

-- AddForeignKey
ALTER TABLE "Equipment" ADD CONSTRAINT "Equipment_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_equipmentId_fkey" FOREIGN KEY ("equipmentId") REFERENCES "Equipment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BorrowRequest" ADD CONSTRAINT "BorrowRequest_borrowerId_fkey" FOREIGN KEY ("borrowerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BorrowRequest" ADD CONSTRAINT "BorrowRequest_reviewedBy_fkey" FOREIGN KEY ("reviewedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BorrowRequest" ADD CONSTRAINT "BorrowRequest_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Borrowing" ADD CONSTRAINT "Borrowing_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "BorrowRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Borrowing" ADD CONSTRAINT "Borrowing_issuedBy_fkey" FOREIGN KEY ("issuedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnRecord" ADD CONSTRAINT "ReturnRecord_borrowingId_fkey" FOREIGN KEY ("borrowingId") REFERENCES "Borrowing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnRecord" ADD CONSTRAINT "ReturnRecord_receivedBy_fkey" FOREIGN KEY ("receivedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
