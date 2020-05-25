From: Andy Smith <andy@strugglers.net>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 19:42:45 +0000
Message-ID: <20200525194245.GV17408@bitfolk.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
 <a755c889-a5bd-1ff3-6a9f-4274b7d7fc83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a755c889-a5bd-1ff3-6a9f-4274b7d7fc83@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 25, 2020 at 09:35:20PM +0200, Thomas Grawert wrote:
> >Someone unattributed wrote:
> >Are you sure about this? From what I can see debian 10 ships with mdadm
> >v4.1 and newer kernels than 4.9.
> >
> I shall check before yelling out some shit...
> It´s currently running Debian 9.

$ lsb_release -d && mdadm --version && uname -r
Description:    Debian GNU/Linux 10 (buster)
mdadm - v4.1 - 2018-10-01
4.19.0-9-amd64

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
