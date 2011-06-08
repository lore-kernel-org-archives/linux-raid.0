From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 10:06:17 +0200
Message-ID: <4DEF2D79.50009@xunil.at>
References: <4DEE6A11.1030205@xunil.at> <4DEE84F0.2030205@harddata.com> <4DEEBB66.7080802@nybeta.com>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEEBB66.7080802@nybeta.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 08.06.2011 01:59, schrieb Thomas Harold:

> Well, with both a pair of RAID1 arrays and a pair of RAID-10 arrays, you
> can lose 2 disks without losing data, but only if the right 2 disks fail.
> 
> With RAID6, any two of the four can fail without data loss.

Yes, that was my initial reason to try that.

> (I still prefer RAID-10 over RAID-6 unless space is at an absolute
> premium.  But for a four-disk setup, net disk space is the same and it's
> just a question of whether you want the speed of RAID-10 or the
> reliability of RAID-6.)

Reliability. There are backups done to that array.
