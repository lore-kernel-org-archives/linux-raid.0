From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Checking the sanity of SATA disks
Date: Tue, 4 Oct 2005 14:42:58 +0000
Message-ID: <62b0912f0510040742v3d0983b2mf5b93a17e8ed8bba@mail.gmail.com>
References: <20051004142913.GK6594@strugglers.net>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004142913.GK6594@strugglers.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: andy@lug.org.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith wrote:
> I tried simply doing a
>
>         dd if=/dev/sd[abcd] of=/dev/null
>
> To check each disk in a very unsubtle fashion, but it drives the
> load average on the machine way way up (like to 20+)

Checked that the disks are using DMA transfers (use 'hdparm')?
