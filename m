From: Wolfram Schlich <lists@schlich.org>
Subject: Re: Version info wrong
Date: Sat, 22 Mar 2003 15:14:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030322141433.ALLYOURBASEAREBELONGTOUS.C8209@bla.fasel.org>
References: <20030322140508.GA804@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030322140508.GA804@hvs.envisage.co.za>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Hendrik Visage <hvisage@envisage.co.za> [2003-03-22 15:11]:
> HI there,
> 
>  bash-2.05b# pwd
>  /usr/src/raidtools-1.00.3
>  bash-2.05b# grep -i version common.h
>  #define MKRAID_MAJOR_VERSION            (0)
>  #define MKRAID_MINOR_VERSION            (90)
>  #define MKRAID_PATCHLEVEL_VERSION       (0)

Looks like that's just the *mkraid*-version, not the raidtools package
version. Just try "raidstart -V", it does show another version number
as well.
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
