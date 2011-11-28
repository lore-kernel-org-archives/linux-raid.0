From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: linear raid, is partial recovery possible?
Date: Mon, 28 Nov 2011 16:00:57 -0600
Message-ID: <4ED40499.3060903@hardwarefreak.com>
References: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/28/2011 2:06 PM, wilsonjonathan wrote:

> Or perhaps it is dependent on the file system on the array, 

It is.

> eg. ext
> works by trying to place files distant to each other to help reduce the
> possibility of fragmentation?

That's not relevant.  What is relevant is where the filesystem metadata
is stored, if any of it was lost when the disk died, and if the
filesystem can recover itself with a repair operation.

I know of one such recovery of a 60TB XFS filesystem residing on a combo
mdraid linear array over 5 hardware RAID6 arrays, after 1 of the 5
constituent arrays suffered complete failure.  xfs_repair deleted the
entries from directory structure whose files were missing, allowing
normal access to all other files.  This was an extremely lucky outcome
in this case and was only possible due to the specific on disk metadata
layout of this individual filesystem. XFS would likely not be able to
recover from such a failure in all cases.

You're using EXT of some flavor.  I suggest you read everything you can
about the EXT version involved here, ask on the respective mailing list.

Good luck.

-- 
Stan
