From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 08:07:52 +0800
Message-ID: <4DD9A558.7000802@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD99FF2.2030609@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/11 07:44, Brad Campbell wrote:
> He used WD commodity drives on a "hardware" RAID enclosure that needed TLER. The RAID-5 kicked out 4
> drives in a short period of time, so he power cycled it and re-initialised the array and it came up
> fine, but blank (as it would as he re-initialised it).
>

Just to clarify that as it was somewhat muddled. The initial failure was on an unspecified array 
with unspecified drives and resulted in a blank array. The backup failure was TLER related using WD 
GP drives on a hardware array and was left unresolved.

That's still not concrete evidence of those drives failing, it's just using the wrong tool for the 
wrong job.
