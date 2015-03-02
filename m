From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 2 Mar 2015 14:10:03 -0700
Message-ID: <CAJCQCtRdYmtx6PTyif6mv_j8htf5hYNZPq3SubJxQoyjULdZPA@mail.gmail.com>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
	<CAJCQCtR1th-V67c7dwZxNBFqKZ=96sAVLzyp4zscO-wPv9jA9g@mail.gmail.com>
	<BLU436-SMTP202531F6FEBD121B8D09E7498100@phx.gbl>
	<CAJCQCtTVA6ntASWFtWMw7ZEwu=8jH+UjvN8avPZ8jXZ1_4BQXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtTVA6ntASWFtWMw7ZEwu=8jH+UjvN8avPZ8jXZ1_4BQXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This won't help me, but you should report kernel and mdadm version,
and include the mdadm -E and -D output for the array and one of the
drives. Someone who knows more about the details might know of some
obscure bug that explains this. More likely it's normal behavior and
I'm just not understanding why the two sets of values are off.
