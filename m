From: Phil Turmel <philip@turmel.org>
Subject: Re: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Tue, 11 Oct 2016 16:26:49 -0400
Message-ID: <dca8ee98-3561-aa97-8e09-7b23eb3b969a@turmel.org>
References: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: moft@fmailbox.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/2016 01:26 PM, moft@fmailbox.com wrote:
> (1) The changelog refers to 'near' and 'offset' layouts, but doesn't mention 'far'.

Historically "far" has not been reshapeable at all.  I don't recall
seeing a patch that implemented it.  If you attempt it and it doesn't
support it, mdadm will refuse without hurting your array.  Same is true
for other reasons to reject growing.  mdadm gives an error before
touching the array.

You can get a definitive answer by setting up a set of small loop
devices in an array that mimics your setup and attempting to grow that
test array.

There have been bugs with SElinux and systemd preventing the reshape
task from forking properly from the command line tool.  The array is
then stuck at reshape position 0.

Phil
