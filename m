From: Frank van Maarseveen <frankvm@xs4all.nl>
Subject: Re: Best Practice for Raid1 Root
Date: Sun, 18 Jan 2004 22:58:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040118215833.GA15558@janus>
References: <4005D408.8060002@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4005D408.8060002@physics.ucsd.edu>
To: linux-raid@vger.kernel.org
Cc: Terrence Martin <tmartin@physics.ucsd.edu>
List-Id: linux-raid.ids

As has been pointed out it can be troublesome to handle half-broken
disks. And its difficult to test. I'd just boot from an USB memory
stick (or a CF card + USB reader, something I use). That way the possible
failure of moving parts in your system gets separated from the boot
process itself. And its easier to test.

-- 
Frank
