From: David Greaves <david@dgreaves.com>
Subject: Re: Autostarting arrays with V1 metadata
Date: Thu, 08 May 2008 09:19:04 +0100
Message-ID: <4822B778.4070502@dgreaves.com>
References: <4821EEFB.1040501@bluecherry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4821EEFB.1040501@bluecherry.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Winslow <rain@bluecherry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Winslow wrote:
> I've noticed that (as of 2.6.25, at least) the kernel doesn't autostart
> arrays with V1 metadata.  In autostart_arrays(), md_import_device() is
> called for 0.90 arrays only, and there's currently no sort of
> autodetection of the superblock position for V1 metadata.
> 
> Is this simply a matter of the code being unwritten, or are there other
> reasons that V1 arrays aren't autostarted (such as the SB format being
> unfinished)?  My only real motivation to use V1 metadata is the unhashed
> homehost field, which I'll give up if the SB format hasn't stabilized yet.
> 
> Thanks,

Also, FYI:
  http://linux-raid.osdl.org/index.php/Autodetect

and
  http://linux-raid.osdl.org/index.php/RAID_Boot
