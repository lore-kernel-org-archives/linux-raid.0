From: david@lang.hm
Subject: Re: limits on raid
Date: Sun, 17 Jun 2007 13:44:28 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706171340070.31145@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org>
 <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org> <20070617132809.GB7806@animx.eu.org>
 <Pine.LNX.4.64.0706171019490.24938@twinlark.arctic.org> <20070617193025.GA8770@animx.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070617193025.GA8770@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: dean gaudet <dean@arctic.org>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 17 Jun 2007, Wakko Warner wrote:

>> you can also easily move an ext3 journal to an external journal with
>> tune2fs (see man page).
>
> I only have 2 ext3 file systems (One of which is mounted R/O since it's
> full), all my others are reiserfs (v3).
>
> What benefit would I gain by using an external journel and how big would it
> need to be?

if you have the journal on a drive by itself you end up doing (almost) 
sequential reads and writes to the journal and the disk head doesn't need 
to move much.

this can greatly increase your write speeds since

1. the journal gets written faster (completeing the write as far as your 
software is concerned)

2. the heads don't need to seek back and forth from the journal to the 
final location that the data gets written.

as for how large it should be, it all depends on the volume of your 
writes, once the journal fills up all writes stall until space is freed in 
the journal, IIRC Ext3 is limited to 128M, with todays drive sizes I don't 
see any reason to make it any smaller.

David Lang
