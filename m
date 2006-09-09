From: Nix <nix@esperi.org.uk>
Subject: Re: Care and feeding of RAID?
Date: Sat, 09 Sep 2006 16:56:06 +0100
Message-ID: <87venxkp9l.fsf@hades.wkstn.nix>
References: <44FD722C.7050608@waldoware.com>
	<Pine.LNX.4.56.0609051414310.17570@lion.drogon.net>
	<44FD91D1.7090501@maine.edu>
	<Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
	<edlu43$jo4$4@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edlu43$jo4$4@sea.gmane.org> (Mario Holbe's message of "6 Sep 2006 08:42:21 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6 Sep 2006, Mario Holbe spake:
> You don't necessarily need one. However, since Neil considers in-kernel
> RAID-autodetection a bad thing and since mdadm typically relies on
> mdadm.conf for RAID-assembly

You can specify the UUID on the command-line too (although I don't).

The advantage of the config file from my POV is that it lets me activate
*all* my RAID arrays with one command, and the command doesn't change, no
matter how complex the array configuration. (I'll admit that the sheer
number of options to mdadm has always overwhelmed me to some degree,
despite the excellent documentation, so I prefer approaches that keep
a working command-line unchanged, especially for something as critical
as boot-time assembly.)

-- 
`In typical emacs fashion, it is both absurdly ornate and
 still not really what one wanted.' --- jdev
