From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 16:52:32 +0100
Message-ID: <200501051652.32346.maarten@ultratux.net>
References: <200501051509.j05F9a925718@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501051509.j05F9a925718@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 05 January 2005 16:09, Guy wrote:
> Dude!  That's a lot of mp3 files!  :)

Indeed.  I "only" have this now:

/dev/md1              590G  590G  187M 100% /disk

md1 : active raid5 sdb3[4] sda3[3] hda3[0] hdc3[5] hde3[1] hdg3[2]
      618437888 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

...but 4 new 250 GB disks are on their way as we speak. :-)

P.S.:  This is my last post for a while, I have very important work to get 
done the rest of this week.  So see you all next time!

Regards,
Maarten



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
> Sent: Wednesday, January 05, 2005 4:44 AM
> To: RAID Linux
> Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
> crashing repeatedly and hard)

> Peter T. Breuer wrote:
> > If you do an md5sum on file contents and compare with a previous md5sum
> > run, then it will be detected provided that the error occurs in a file,
> > but assuming that your disk is 50% full, that is only 50% likely.
> >
> > I.e. "it depends on your test".
>
> brad@srv:~$ df -h | grep md0
> /dev/md0              2.1T  2.1T  9.2G 100% /raid

-- 


