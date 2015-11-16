From: "John Stoffel" <john@stoffel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 14:52:37 -0500
Message-ID: <22090.13317.824290.574006@quad.stoffel.home>
References: <22090.1097.258820.65463@quad.stoffel.home>
	<564A203C.1020309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564A203C.1020309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 11/16/2015 11:28 AM, John Stoffel wrote:
>> 
>> Guys,
>> 
>> I'm starting to get tons of errors on my various mixed 1 and 2Tb
>> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
>> It's time to start replacing them and I think I want to either go with
>> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
>> SSDs to use with lvmcache for speedup.
>> 
>> Any comments?

Phil> The data sheet for the Blacks implies that they do *not* have
Phil> TLER, also known as ERC.  This is vital for proper operation
Phil> out-of-the-box in any Linux Raid environment, with the exception
Phil> of raid0.

So I like the 5 year warranttee on the blacks, but it does look like
the REDs are the way to go.  And I think I'll also go with splitting
my data between seagate and WD and possibly Hitachi (I know, they've
been bought by WD) to make a three way RAID 1 mirror across 4Tb
drives.  Yes, I'd get more room out of RAID5, but I'm not that silly,
and I don't need to move to 4 x 4Tb in RAID6 either.

Who knows... still pricing things out.

John
