From: Gunnlaugur Thor Briem <gthb@hi.is>
Subject: Re: Status of Promise drivers?
Date: Wed, 04 Feb 2004 15:02:50 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4021099A.6090209@hi.is>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20040203192336.A5570@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040203192336.A5570@nettis.grimsta>
To: Daniel Brahneborg <daniel.com@wtnord.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Daniel Brahneborg wrote:

>>It's beta, and stable.
> 
> 
> Since I'm paranoid: What motherboards has it been tested and
> verified with?

Blessed are the paranoid: take a look at

http://bugzilla.kernel.org/show_bug.cgi?id=2011

(which hadn't been reported when Jeff Garzik called the driver stable)

Don't know about any other motherboards, but in any case your kernel is 
likely to hang when trying to use a PDC 20376 (on a motherboard, as in 
my case, or on a separate board), for the time being.

	- Gulli

