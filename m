From: Jeff Breidenbach <breidenbach@gmail.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Wed, 4 Jan 2006 16:23:58 -0800
Message-ID: <e03b90ae0601041623w6c683d63ye1b02d78c146396f@mail.gmail.com>
References: <E26C409DCE780347BD93D08771FF08E90129DB3D@usahm236.amer.corp.eds.com>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E26C409DCE780347BD93D08771FF08E90129DB3D@usahm236.amer.corp.eds.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Interesting paper, thanks. Unfortunately, decode bandwidth
when erasures are present (e.g. drives have failed) is not
discussed. This is by far the speed bottleneck for Reed-Solomon
and a potential hangup for a RS personality in md.

Jeff
