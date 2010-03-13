From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 15:19:23 +0200
Message-ID: <4B9B90DB.4020809@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>	 <4B9ADC61.7080007@edu.physics.uoc.gr>	 <4B9AE28C.8030905@edu.physics.uoc.gr> <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com> <4B9B8DFC.30907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9B8DFC.30907@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/10 15:07, Ric Wheeler wrote:
> I would agree that it would be key to try this on a newer kernel & on 
> a 64 bit box. If you have an issue with a specific vendor release, you 
> should open a ticket/bugzilla with that vendor so they can help you 
> figure this out.
>
> ric

I will try Fedora 12/64bit on Monday when I have physical access.

Right now all tests have failed.
OS in Centos 5.4 x86 PAE so I opened a ticket both in Centos and Redhat 
bugzilla.
I don't have any contract with redhat but I hope they will give a try on 
this.

https://bugzilla.redhat.com/show_bug.cgi?id=573185
http://bugs.centos.org/view.php?id=4239

My feelings are that it has to do with the software raid layer and not
the filesystem (ext4, xfs, gfs all died).
The filesystem seems to not get the appropriate physical/logical
quandaries from the raid layer.

Unless the x86 kernel is not capable of addressing
large filesystems as it is documented (16TB as you said).

best regards,

Giannis

