From: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Subject: Re: now on to tuning....
Date: Wed, 09 Mar 2005 10:47:49 +0100
Message-ID: <422EC645.1010305@variant.ch>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi peter

peter.greis@ubs.com wrote:
> I have been lurking for a while.... I recently put together a raid 5
> system (Asus K8NE SIL 3114/2.6.8.1 kernel) with 4 300GB SATA Seagate
> drives (a lot smaller than the bulk of what seems to be on this
> list!). Currently this is used for video and mp3 storage, being
> Reiser on LVM2.

beware that LVM2 _can_ affect your performance. I too believed that the 
concept of dynamic drives is good, but I experienced a performance hit 
of about 50% (especially in sequential reads).

see my blog entry describing how I built my 2TB file-server at 
http://variant.ch/phpwiki/WikiBlog/2005-02-27 for some numbers and more 
explanation.

the K8NE has the same SiI 3114 controller as the board I used has; it is 
connected by a 33mhz 32bit PCI bus and maxes out at 133MiB/s, so for 
maxmimum performance you might want to connect only two drives to this 
controller, the other two to the nforce3 chipset SATA ports.

> Bonnie++ to test, but with which parameters ? 

normally it's enough to specify a test-file larger (e.g. twice) the 
memory capacity of the machine you are testing. for a machine with 1GiB RAM:

# bonnie++ -s 2gb {other options}

you might as well want to specify the "fast" option which skips per-char 
operations (which are quite useless to test IMHO):

# bonnie++ -f {other options}

HTH
nicola
