From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: MD device id change
Date: Fri, 4 Apr 2003 08:16:13 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16012.45741.447317.341813@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.33.0304031754490.5184-100000@worf.desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alexander Kisselev on Thursday April 3
To: Alexander Kisselev <kisselev@mail.desy.de>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 3, kisselev@mail.desy.de wrote:
> 
>   Here is the question: is there an easy way to change RAID device ID?
> If not, is the following sequence correct in my case (1-disk RAID linear):
> 
>   - stop device;
>   - 'dd' 4k RAID superblock from /dev/sda2 at offset 292021440;
>   - change 4-byte field at offset 11 (md_minor) to the desired number
>     (say '5' for md5);
>   - copy superblock back;
>   - reboot;

Sort of, but it is much easier to get mdadm to do this.
Get mdadm 1.2.0 and check out
   --assemble --update=super-minor

in the documentation.

NeilBrown
