From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all
 drives "non-fresh"
Date: Sun, 07 Aug 2011 21:32:50 -0700
Message-ID: <4E3F66F2.3030300@aeoncomputing.com>
References: <4E3F4BD0.5060807@aeoncomputing.com> <20110808125608.7ceeaa02@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110808125608.7ceeaa02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am now able (thanks to Neil's suggestion) manually assemble the 
/dev/md3 raid10 volume using:

mdadm -A /dev/md3 /dev/sd[cdefghijklmnopqrstuv]1

and then manually adding the spares back with: mdadm --add /dev/md3 
/dev/sd[wxyz]1

The data is intact, phew! I am still unable to start the raid using a 
config file. I gracefully stopped the raid using 'mdadm --stop /dev/md3' 
and then tried 'mdadm -A /dev/md3 -c /etc/mdadm.conf.mdt' and it fails 
to start.

I recreated the config file using 'mdadm --examine --scan > 
/etc/mdadm.conf'. Then I stopped /dev/md3 and tried to assemble it again 
using 'mdadm -A /dev/md3' and it fails to assemble and start.

It is good I can start the raid manually but it isn't supposed to work 
like that. Any idea why assembling from a config file would fail? Here 
is the latest version of the config file line (made with mdadm --examine 
--scan):

ARRAY /dev/md3 level=raid10 num-devices=20 metadata=0.90 spares=4 
UUID=e17a29e8:ec6bce5c:f13d343c:cfba4dc4

--Jeff

On Sun, Aug 7, 2011 at 7:56 PM, NeilBrown<neilb@suse.de 
<mailto:neilb@suse.de>>wrote:

    On Sun, 07 Aug 2011 19:37:04 -0700 Jeff Johnson
    <jeff.johnson@aeoncomputing.com
    <mailto:jeff.johnson@aeoncomputing.com>> wrote:

    >  Greetings,
    >
    >  I have a 20 drive raid-10 that has been running well for over one
    year.
    >  After the most recently system boot the raid will not assemble.
    >  /var/log/messages shows that all of the drives are "non-fresh".

    --snip--

    You really don't want that 'devices=" clause in there.  Device names can
    change.. 

    --snip--

    >            Events : 90
    >            Events : 90
    >            Events : 92
    >            Events : 92
    >            Events : 92
    >            Events : 92

    So the spares are '92' and the others are '90'.  That is weird...

    However you should be able to assemble the array by simply listing
    all the
    non-spare devices:

      mdadm -A /dev/md3 /dev/sd[c-v]1

    NeilBrown


--
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson "at" aeoncomputing.com <mailto:jeff.johnson@aeoncomputing.com>
www.aeoncomputing.com <http://www.aeoncomputing.com/>
t:858-412-3810 x101 <tel:858-412-3810%20x101>  f:858-412-3845 
<tel:858-412-3845>


4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

