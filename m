From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID 5 reshape stalled at 77.5% - next steps??
Date: Sun, 29 Jan 2017 04:33:38 +0500
Message-ID: <20170129043338.235723a7@natsu>
References: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
        <20170129041559.723d8259@natsu>
        <CAF-KpgbmnOmbCXDi6_xr9d9Ms5rFt+D3WN=3gu=7xFv0G6U5vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgbmnOmbCXDi6_xr9d9Ms5rFt+D3WN=3gu=7xFv0G6U5vw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

On Sat, 28 Jan 2017 18:29:32 -0500
George Rapp <george.rapp@gmail.com> wrote:

> Attempting to re-add /dev/sdg4 to the array fails on a busy device:
> 
> # mdadm --manage /dev/md4 --re-add /dev/sdg4
> mdadm: Cannot open /dev/sdg4: Device or resource busy

You need to remove it first

  mdadm --remove /dev/md4 /dev/sdg4

or 

  mdadm --remove /dev/md4 faulty

But honestly I am not sure if simply removing and re-adding will bring your
reshape back to its working order at this point.

Also you should figure out why did it fail in the first place. Check
SMART, check dmesg further back rather than a few lines only. Maybe the disk
needs a replacement, not just a blind re-add.

-- 
With respect,
Roman
