From: Phil Turmel <philip@turmel.org>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 13:30:41 -0400
Message-ID: <51DD9A41.5090307@turmel.org>
References: <51DD4EF0.6020509@perpetual-data.com> <20130710131119.GA26658@cthulhu.home.robinhill.me.uk> <51DD6D07.1060401@perpetual-data.com> <51DD74F0.8020006@turmel.org> <51DD79B4.3000102@perpetual-data.com> <51DD7C2C.2080901@turmel.org> <51DD8185.7070201@perpetual-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD8185.7070201@perpetual-data.com>
Sender: linux-raid-owner@vger.kernel.org
To: Priya Kamala <priya.kamala@perpetual-data.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/2013 11:45 AM, Priya Kamala wrote:
> On 10/07/2013 16:22, Phil Turmel wrote:
>> Did you have an idea of number of read error events?  "Pending" sector
>> counts on the problem drive might be a useful number to report.  (Or
>> just report complete output of "smartctl -x" for each drive.)
> Unfortunately I don't have this information, as this is a post-mortem
> analysis of the failure on a customer system.
>> Meanwhile, what distro, kernel, and mdadm versions are involved here?
> I'm working with a distro based on Centos running 2.6.21.1 kernel and
> mdadm 2.6.

That explains your experience.  Your kernel dates from April 2007.
Tolerance for corrected read errors was added in December 2009.  (Robert
Becker, 1e50915f, to be specific.)

You need a newer kernel.

Phil
