From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid1-diseaster on reboot: old version overwrites new version
Date: Sat, 2 Apr 2005 18:27:34 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504021825350.30253@lion.drogon.net>
References: <424EBDB7.2000106@goldfisch.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424EBDB7.2000106@goldfisch.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Apr 2005, peter pilsl wrote:

> The only explantion to me is, that I had the wrong entry in my
> lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
> So maybe root was always mounted as /dev/hda6 and never as /dev/md2,
> which was started, but never had any data written to it. Is this a
> possible explanation?

It's possible - but I think the root= parameter needs to correspond to
whats in the /etc/fstab file - I'd check that too if it's still possible.
I've no experience with reiser though.

Gordon
