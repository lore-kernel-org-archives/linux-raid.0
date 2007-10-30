From: David Greaves <david@dgreaves.com>
Subject: Re: Bad drive discovered during raid5 reshape
Date: Tue, 30 Oct 2007 11:17:57 +0000
Message-ID: <472712E5.10806@dgreaves.com>
References: <47258776.9020601@sisna.com> <18214.53051.652280.492087@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18214.53051.652280.492087@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kyle Stuart <kstuart@sisna.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday October 29, kstuart@sisna.com wrote:
>> Hi,
>> I bought two new hard drives to expand my raid array today and
>> unfortunately one of them appears to be bad. The problem didn't arise

> Looks like you are in real trouble.  Both the drives seem bad in some
> way.  If it was just sdc that was failing it would have picked up
> after the "-Af", but when it tried, sdb gave errors.

Humble enquiry.... :)

I'm not sure that's right?
He *removed* sdb and sdc when the failure occurred so sdc would indeed be non-fresh.

The key question I think is: will md continue to grow an array even if it enters
degraded mode during the grow?
ie grow from a 6 drive array to a 7-of-8 degraded array?

Technically I guess it should be able to.

In which case should he be able to re-add /dev/sdc and allow md to retry the
grow? (possibly losing some data due to the sdc staleness)

David


