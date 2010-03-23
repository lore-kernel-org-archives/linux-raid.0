From: Randy Terbush <randy@terbush.org>
Subject: Questions regarding startup of imsm container
Date: Mon, 22 Mar 2010 21:56:01 -0600
Message-ID: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having a go at building a raid5 array using the new imsm support and
having good luck keeping drives in the array, etc. Nice work. I have a
few questions though as I am having some trouble figuring out how to
properly start this container.

# mdadm --version
mdadm - v3.1.2 - 10th March 2010

# mdadm -Es
ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c

# ls -l /dev/md/
total 0
lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127

As you can see, the name for the link in /dev/md does not agree with
the name that the Examine is coming up with.

Is it better to just forgo the ARRAY statements and go with an AUTO +imsm?

And last, does the concept of a write-intent bitmap make sense on an
imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
-Gb internal on either device.

Thanks for your help
