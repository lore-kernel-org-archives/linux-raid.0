From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: segfault in mdadm v2.6.4
Date: Fri, 4 Apr 2008 09:43:02 -0700
Message-ID: <e9c3a7c20804040943j9b88d52vc987b642edd2544a@mail.gmail.com>
References: <2C1F2D1D-8799-4E11-8CDB-1827769496F3@cloud9.net>
	 <bb145bd20804040305o485cbf02u2abff0311fd35079@mail.gmail.com>
	 <e9c3a7c20804040901p4583bebev85c66895aa448472@mail.gmail.com>
	 <45860.192.168.1.3.1207325666.squirrel@frank.mercea.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45860.192.168.1.3.1207325666.squirrel@frank.mercea.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: brett@cloud9.net
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 4, 2008 at 9:14 AM, Brett Dikeman <brett@cloud9.net> wrote:
> > There is a known issue with arrays in the "read-auto" state and "mdadm
>  > --monitor".  The attached patch addresses this.
>
>  Ah- I forgot that, yes, mdadm monitor was running.  I was *wondering* what
>  mdadm process was hanging around to segfault- duh! :-)
>
>
>
>  > What is more concerning is the usb-storage hangs.  Do you have logs
>  > from when it hung?
>
>  Nope- absolutely nothing useful from dmesg or /var/log/messages.  The
>  array simply grinds to a halt.  I think it might be the USB bridge, since
>  this morning I woke up to find the same drive as previously mentioned,
>  with its access light on continuously (didn't happen the first time.)  It
>  did get further along in the sync- 66.7%, very roughly twice as far as the
>  first time.
>
>  /proc/mdstat keeps getting updated during all this; the (obviously
>  averaged) rebuild rate average drops steadily.
>
>   I don't have any info handy on the USB device, but it's an older
>  SATA<->USB/eSATA AMS Venus (expensive but otherwise nice case.  Has a
>  silent 80mm fan in it that doesn't move much hair, but does keep drives
>  cooler.)  It dates back to when manufacturers were still making "L"
>  "eSATA" ports (grr.)  The other USB bridge is a Vantec multi-interface
>  bare adapter.  That one seemed fine.
>
>  Ask away with things you'd like me to try- I'll get more info this
>  evening, and I might try picking up a second one of the Vantec interfaces
>  if I can (they're cheap- and have proven endlessly useful.)
>  Unfortunately, my intended destination for this array uses Adaptec 1205SA
>  PCI cards, which idiotically don't support drives over 500GB and hang
>  during their POST :(
>

The output from sysrq-w after the hang might shed some light.  I have
copied linux-usb [1] in case they recognize the devices you mentioned.

--
Dan

[1]: original report http://marc.info/?l=linux-raid&m=120728545823965&w=2
