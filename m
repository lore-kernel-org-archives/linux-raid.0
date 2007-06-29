From: David Greaves <david@dgreaves.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 08:54:12 +0100
Message-ID: <4684BAA4.4010905@dgreaves.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl> <20070629050024.GO31489@sgi.com> <4684B750.5030001@dgreaves.com> <20070629074322.GT31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070629074322.GT31489@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
List-Id: linux-raid.ids

David Chinner wrote:
> On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
>> What happens if a filesystem is frozen and I hibernate?
>> Will it be thawed when I resume?
> 
> If you froze it yourself, then you'll have to thaw it yourself.

So hibernate will not attempt to re-freeze a frozen fs and, during resume, it 
will only thaw filesystems that were frozen by the suspend?

David

