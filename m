From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: blog entry on RAID limitation
Date: Fri, 27 Jan 2006 14:09:56 +0100
Message-ID: <62b0912f0601270509l158e87f2maf7162ba5e5a6da4@mail.gmail.com>
References: <20060122115231.9294.qmail@web52910.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060122115231.9294.qmail@web52910.mail.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rik Herrin wrote:
> Wouldn't connecting a UPS + using a stable kernel
> version remove 90% or so of the "RAID-5 write hole"
> problem?

There are some RAID systems that you'd rather not have redundant power on.

Think encryption.  As long as a system is online, it's normal for it
to have encryption keys in memory and it's disk systems mounted
through the decryption system.  You wouldn't want someone to be able
to steal your server along with the UPS and stuff it in a van with a
power inverter :-).
