From: Phil Turmel <philip@turmel.org>
Subject: Re: Kernel preventing (extra) spare disk in array from entering
 standby
Date: Tue, 24 Oct 2017 14:30:43 -0400
Message-ID: <f656c779-f376-82a2-cf2f-769767b478d6@turmel.org>
References: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=c3=b8rnar_Ness?= <bjornar.ness@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/24/2017 10:32 AM, Bjørnar Ness wrote:
> When looking into disk power-save, I notice that all spare disks attached
> to a rebuilding array is sent some type of write request every around 5 second.
> 
> In my case, where I have perhaps 12 spares attached to an array, it
> unnecessary prevents the remaining 11 spares from entering standby
> mode when a rebuild is happening.
> 
> Is it possible to do something about this?
> 
That sounds like writes to the write-intent bitmap, which happens to all
devices in an array while degraded.

Why do you have 12 spares attached to the array?  That seems a bit
excessive.

Phil
