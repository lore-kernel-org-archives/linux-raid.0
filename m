From: Phil Turmel <philip@turmel.org>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 07:53:02 -0400
Message-ID: <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
References: <5800AE09.70608@bluewin.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5800AE09.70608@bluewin.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/14/2016 06:06 AM, Ramon Hofer wrote:

> From what I was reading [1,2] it is useful for faster rebuilds.
> But why is it not present for md[1234] as I used the same command to
> create these RAIDs?
> Is it only possible for the last of the linear devices, or is it only
> used for almost empty devices, or was the bitmap introduced in a recent
> update?

Bitmaps have been available for a long time, but including them on a new
array by default is recent.  They are most useful if a device is
unexpectedly disconnected but otherwise OK.  mdadm --re-add will allow
that device to rejoin the array and only the missing data (tracked by
the bitmap) will have to be written to sync it up.

> I wonder if I should and could add a bitmap for the other devices as well?

There is a performance hit, so it should be considered on a case by case
basis.

Phil
