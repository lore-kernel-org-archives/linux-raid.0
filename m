From: Asdo <asdo@shiftmail.org>
Subject: Re: Does MD solve write hole issue for RAID5/RAID6?
Date: Wed, 03 Mar 2010 14:40:53 +0100
Message-ID: <4B8E66E5.9050606@shiftmail.org>
References: <d19eda751003030417o3a7ec761ua54e93875002410a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <d19eda751003030417o3a7ec761ua54e93875002410a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rj <ratnadeep@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rj wrote:
> Hi,
> I wanted to know if md solves write hole issue for RAID5/RAID6?
>   
No but the filesystem can do that, ext3/4 and XFS in particular, if well 
aligned on the RAID, if you are creating new files and not updating old 
files (i.e. doesn't work for databases).
For full write hole avoidance you need to wait for Btrfs (and I don't 
know the state of raid-5/6 on btrfs), or use ZFS on Solaris or Freebsd.
> Also, does md support RAID 50 level ?
>   
Not directly, but you can create that manually by overlaying a raid 0 
over 1+ raid5's.
