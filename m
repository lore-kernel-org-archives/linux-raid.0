From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: quick Q re raid reconstruction
Date: Fri, 02 Dec 2005 09:42:19 +1100
Message-ID: <438F7C4B.1090404@eyal.emu.id.au>
References: <438EE429.2030903@eyal.emu.id.au> <17295.29744.13292.368041@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17295.29744.13292.368041@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
>>Q1) What is the correct command to bring these three up as
>>    degraded?
> 
> 
>   mdadm --assemble --force /dev/mdX /dev/sd[abc]1
> 
> However this won't work with the superblocks you have. So
> 
>   mdadm --create /dev/mdX -l5 -c256 -n4 missing /dev/sda /dev/sdb /dev/sdc

I do not see 'missing' the the mdadm manpage, but maybe Debian is too
far behind?

# mdadm --version
mdadm - v1.9.0 - 04 February 2005

Should I use 2.1 (is it safe to upgrade to it)?

I built it anyway and I do not see 'missing' listed in
	mdadm --create --help

Reading the new mdadm.man I can see what .missing' does, good.

I got it up (fsck now running), thanks a lot.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
