From: Derek Vadala <derek@cynicism.com>
Subject: Re: AW: raid1 reconfig failed to work! help!
Date: Wed, 2 Oct 2002 10:06:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0210021005100.14300-100000@jaded.cynicism.com>
References: <200210021700.42481.devel@qnet.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200210021700.42481.devel@qnet.ro>
To: Alex <devel@qnet.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2 Oct 2002, Alex wrote:

> Another question: did you know a program for monitoring raid array and
> when a hdd is down(mark failed) to start some beeps?

Try mdadm (http://www.cse.unsw.edu.au/~neilb/source/mdadm/). It has a
monitor mode which can be customized to execute any program when an array
(or array member disk) fails. It can also send email alerts.

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

