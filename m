From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm --incremental and different config file
Date: Mon, 1 Dec 2008 11:24:08 +1100 (EST)
Message-ID: <4844862be26c89d648e57bf90aae498d.squirrel@neil.brown.name>
References: <200811301551.08646.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200811301551.08646.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, December 1, 2008 1:51 am, Wilhelm Meier wrote:
> Hi,
>
> how can I use a different config file for the incremental mode: -c is
> not working in this mode?

Unfortunately you cannot without modifying the code.
If you

  git clone git://neil.brown.name/mdadm
  cd mdadm
  make install

then you will be able to do this.

(i.e. I have just committed a fix).

NeilBrown

