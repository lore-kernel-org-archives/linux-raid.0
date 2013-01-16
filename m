From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Suboptimal raid6 linear read speed
Date: Wed, 16 Jan 2013 13:58:57 +1100
Message-ID: <20130116025857.GA31112@rabbit.us>
References: <20130115123301.GA11948@rabbit.us>
 <50F55046.7050605@turmel.org>
 <20130115125507.GA12184@rabbit.us>
 <50F614F7.20104@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50F614F7.20104@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 15, 2013 at 08:48:23PM -0600, Stan Hoeppner wrote:
> With only 4 drives RAID6 doesn't make sense as RAID10 is superior in
> every way.

Except raid6 can lose any random 2 drives, while raid10 can't.
