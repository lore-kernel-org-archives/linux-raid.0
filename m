From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Storage system
Date: Fri, 7 Feb 2014 16:58:46 -0700
Message-ID: <F9224525-4A9C-40B0-BA2C-75C01AE23C61@colorremedies.com>
References: <20140206180909.GA2419@lazy.lzy> <52F49433.8080904@hesbynett.no> <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
Cc: Matt Garman <matthew.garman@gmail.com>
List-Id: linux-raid.ids


On Feb 7, 2014, at 7:29 AM, Matt Garman <matthew.garman@gmail.com> wrote:

> FWIW, I use a program called "shred" when I'm done with a disk.  It
> makes N (default = 3) passes of writing random data to the disk, and
> an optional final pass of zeroes.  It's time-consuming to complete,
> but takes only 30 seconds to get going. 

Unnecessary. If the drive is alive, use ATA Security Erase with hdparm. The drive then zeros itself. NIST 800-88 lists three levels of sanitization, in order of thoroughness: clear, purge, destroy. Using software utilities to write zeros or a pattern, even multiple times, only qualifies as clear. One ATA Security Erase qualifies for purge. And destroy means to literally shred, disintegrate, pulverize or incinerate.

The main reason ATA Security Erase achieves higher level of sanitization is that it will zero dereferenced sectors - those that don't have an LBA assigned to them. For example, bad sectors which contain latent data but have been removed from use. Software can't zero those because they have no LBA to instruct the drive to overwrite.

ATA Security Erase is also faster, and there's no CPU load.

Chris Murphy

