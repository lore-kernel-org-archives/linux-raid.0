From: <peter.greis@ubs.com>
Subject: RE: now on to tuning....
Date: Wed, 9 Mar 2005 11:53:11 +0100
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E4355@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good point about maxing out the pci bus... - I already use the nForce for mirrored boot drives, so that's not an option. The IDE controllers are empty at the moment (save for a DVD drive); I will give this a thought.

Thanks for the feedback,

-P

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Nicola Fankhauser
Sent: Wednesday, March 09, 2005 10:48 AM
To: linux-raid@vger.kernel.org
Subject: Re: now on to tuning....


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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
