From: Gordon Henderson <gordon@drogon.net>
Subject: Re: swap on raid 1
Date: Tue, 14 Oct 2003 13:01:13 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310141258550.29390@unicorn.drogon.net>
References: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
To: skopel@english.fsu.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Oct 2003 skopel@english.fsu.edu wrote:

> I have been following the discussion of swap on raid 1 and I just want to
> clarify something... I have my swap on /dev/md1, which is a raid1 device
> consisting of /dev/hda2 and /dev/hdc2.
> If one of the drives fails (either hda or hdc), I think the swap will be
> duplicated on the other and the box will continue merrily on, right?

Thats the general idea, and exactly what I have here... (although I'd use
the term 'mirrored' rather than 'duplicated' as that appears more often in
the documentation about RADI1, but it's a minor point)

gordon @ unicorn: cat /proc/swaps
Filename                        Type            Size    Used    Priority
/dev/md1                        partition       499896  53272   -1

gordon @ unicorn: cat /proc/mdstat

...

md1 : active raid1 hdc2[1] hda2[0]
      499904 blocks [2/2] [UU]

...

Gordon
