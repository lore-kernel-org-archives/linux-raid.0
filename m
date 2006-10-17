From: "Andrew Moise" <chops@demiurgestudios.com>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Tue, 17 Oct 2006 13:58:17 -0400
Message-ID: <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
	 <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-poweredge@dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/17/06, Gordon Henderson <gordon@drogon.net> wrote:
> Anyway, it's currently in a RAID-1 configuration (which I used for some
> initial soaktests) and seems to be just fine:
>
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md9              6.8T   33M  6.7T   1% /mnt

  Incidentally, what filesystem are you using?  We may be setting up a
similar situation soon, and I'm considering ext3 and XFS.  ext3
apparently has a low max fs size, though, and I've heard bad things
about XFS's behavior on unclean shutdowns...
