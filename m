From: "Martin Bene" <martin.bene@icomedias.com>
Subject: Checking consistency of Linux software RAID
Date: Mon, 30 Jun 2003 14:58:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Administrationg quite a few systems with HW raid controllers, I've come to
really like a feature that seems to be missing from current SW raid: 

Scheduling a (weekly) complete media scan where all surfaces of all drives
get read; in case of read errors a repair is tried: the content for the
failed sector is reconstructed just as if the drive had completely failed and
rewritten to the failed sector; if reading works afterwards, regard the
repair as successfull and continue using the drive.

Is there any way to do this with SW raid? I truly hate situations where some
sectors on a drive fail silently and you don't notice until a 2nd drive dies
and you find you can't recostruct your raid data becaus of silent "bitrot".

Tnaks for any hints,

Martin
