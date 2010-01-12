From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: No resync
Date: Tue, 12 Jan 2010 17:58:10 +1300
Message-ID: <4B4C0162.5040807@sauce.co.nz>
References: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:

>> Is there a way to  force assemble a stopped array that has too many
>> failed devices, while disabling the resync that would normally occur?
>
> 	Well, of course if the array has too few members to start (even
> after the --force), then it won't start and thus won't recync, but assuming
> one has enough targets to assemble and run the array, I believe
> --asume-clean will do what you want.  It's in the man page.
>

By using force as part of an assemble, all failed devices set to healty 
again and a resync is immediately started.

According to the man page --asume-clean is not an available option for 
assemble.

I have tried --read-only but that is not an otion either.

I need to reassemble without resyncing so I can fsck first.

Regards,

Richard

