From: Priya Kamala <priya.kamala@perpetual-data.com>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 16:45:09 +0100
Message-ID: <51DD8185.7070201@perpetual-data.com>
References: <51DD4EF0.6020509@perpetual-data.com> <20130710131119.GA26658@cthulhu.home.robinhill.me.uk> <51DD6D07.1060401@perpetual-data.com> <51DD74F0.8020006@turmel.org> <51DD79B4.3000102@perpetual-data.com> <51DD7C2C.2080901@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD7C2C.2080901@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/07/2013 16:22, Phil Turmel wrote:
> Did you have an idea of number of read error events?  "Pending" sector
> counts on the problem drive might be a useful number to report.  (Or
> just report complete output of "smartctl -x" for each drive.)
Unfortunately I don't have this information, as this is a post-mortem 
analysis of the failure on a customer system.
> Meanwhile, what distro, kernel, and mdadm versions are involved here?
I'm working with a distro based on Centos running 2.6.21.1 kernel and 
mdadm 2.6.

Thanks,
Priya

