From: Chris Osicki <Krzysztof.Osicki@swisscom.com>
Subject: Q: Moving raid1 array to another host, safe?
Date: Mon, 14 Mar 2005 14:43:14 +0100
Message-ID: <20050314144314.664142c5@mwdsp001>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi

I have two Linux boxes running kernel 2.4.21 having access to two
devices over fibre channel SAN.
What I'm trying to achive is host based mirroring with ability to
"move" the storage from one host to another.
On the firs host I created a raid1 array, put LVM on it, created a
filesystem. To move the storage to the second host I do the following
(on the first host):

deactivate volume group: 
	    vgchange -an dxvg
stop array: 
	    mdadm --misc --stop /dev/md0

Then on the second host:

assemble the array: 
	    mdadm --assemble /dev/md0 /dev/emcpowera  /dev/emcpowerb
activate the volume group: 
	    vgchange -ay dxvg

The following procedure seams to be working OK. 
However, I'm asking myself how safe is it what I'm doing?

Thanks for your time.

Regards,
Chris
