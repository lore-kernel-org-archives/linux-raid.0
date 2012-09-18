From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Subject: Re: What parameters to mdadm, to re-create md device with payload
 starting at 0x22000 position on backing storage?
Date: Tue, 18 Sep 2012 08:53:25 +0200
Message-ID: <50581A65.5050201@statystyka.net>
References: <5056CA7E.5040303@statystyka.net> <20120917174952.GA6559@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120917174952.GA6559@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-09-17 19:49, Robin Hill wrote:

> Your data offset is 272 sectors, which means you'll need to use an older
> mdadm version to re-create the array. Newer versions use 2048 sectors,
> but it looks like version 3.0 uses 272, so grab a copy of that if
> possible.
Does it mean, that with the current raid setup I need to stick to the 
mdadm 3.0, or is there way to convert the arrays to the new layout so I 
can use a recent mdadm? Re-creating the arrays from scratch would be a 
very long and complex enterprise.

Adam

