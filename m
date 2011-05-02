From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Question regarding --backup-file
Date: Mon, 02 May 2011 23:34:18 +0800
Message-ID: <4DBECEFA.1050203@fnarfbargle.com>
References: <000301cc08db$89293160$9b7b9420$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000301cc08db$89293160$9b7b9420$@priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kovari <peter@kovari.priv.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/11 23:13, Peter Kovari wrote:
> Hi all,
>
> I understand, that a change from RAID5 to RAID6 by adding a single disk -
> eg. keeping the number of data disks - requires a backup file throughout the
> whole reshape process. For a larger, multi-TB array this means millions of
> writes to the backup file, which - if i'm correct - means means millions of
> writes to the same physical sectors of the disk that holds the backup file.
> Is this not problematic? How many write operations can a typical drive
> tolerate nowadays? (on the same sectors)

Lots, where Lots >= 1 and Lots < infinity.

I've never seen rotating media specify any form of limitation to writes. 
Have you?

Brad
