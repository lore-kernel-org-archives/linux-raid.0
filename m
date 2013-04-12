From: Phil Turmel <philip@turmel.org>
Subject: Re: Odd --examine output
Date: Fri, 12 Apr 2013 13:21:14 -0400
Message-ID: <5168428A.2070002@turmel.org>
References: <CD8DAF4D.412EF%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD8DAF4D.412EF%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/12/2013 12:47 PM, Vanhorn, Mike wrote:
> On 4/12/13 10:52 AM, "Phil Turmel" <philip@turmel.org> wrote:

[snip /]

>> I guess "lsdrv" didn't work for you.  I'm naturally curious how it
>> failed....
> 
> I don't have an lsdrv command, so I did the 'ls -l' that you suggested.

Ah.  You missed the footnote in the original suggestion.  "lsdrv" is a
script I published on github based on encouragement from others on
linux-raid.  It summarizes a system's storage layout, annotated with
drive, subsystem, and filesystem serial numbers wherever possible.

http://github.com/pturmel/lsdrv

I occasionally poke at it to keep it usable on a variety of distros,
including older ones.  Bug reports welcome.

Phil
