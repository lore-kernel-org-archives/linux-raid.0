From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 17:59:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16396.53737.911347.812076@notabene.cse.unsw.edu.au>
References: <400CD0BF.2010808@upfrontsystems.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jean Jordaan on Tuesday January 20
To: Jean Jordaan <jean@upfrontsystems.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 20, jean@upfrontsystems.co.za wrote:
> Hi all
> 
> I'm having a RAID week. It looks like 1 disk out of a
> 3-disk RAID5 array has failed. The array consists of
> /dev/hda3 /dev/hdb3 /dev/hdc3 (all 40Gb)
> I'm not sure which one is physically faulty. In an attempt
> to find out, I did:
>    mdadm --manage --set-faulty /dev/md0 /dev/hda3

   mdadm --detail /dev/md0
didn't tell you??

> 
> Does anyone here have any comments on what I've done so far,
> or if there's anything better I can do next?

mdadm --assemble /dev/md0 --force /dev/hd[abc]3

should put it back together for you.

NeilBrown
