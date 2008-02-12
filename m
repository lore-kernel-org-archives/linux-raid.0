From: Brendan Conoboy <blc@redhat.com>
Subject: Re: transferring RAID-1 drives via sneakernet
Date: Tue, 12 Feb 2008 12:00:34 -0700
Message-ID: <47B1ECD2.8070406@redhat.com>
References: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>	 <47B1633F.5030403@dgreaves.com> <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: David Greaves <david@dgreaves.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
>> Does the new machine have a RAID array already?
> 
> Yes.. the new machine already has on RAID array.
> After sneakernet it should have two RAID arrays. Is
> there a gotcha?

It's not a RAID issue, but make sure you don't have any duplicate volume 
names.  According to Murphy's Law, if there are two / volumes, the wrong 
one will be chosen upon your next reboot.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
