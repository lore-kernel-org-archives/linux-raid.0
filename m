From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Wed, 3 Jul 2013 14:47:54 -0500
Message-ID: <CAPSPcXjoyn3VjxduJQ3J9fYWVpvOHtph8A+LAvGWHnw+Fxj_tg@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
	<CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
	<51BB8A67.5000605@turmel.org>
	<51BB8B86.9050803@turmel.org>
	<CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
	<alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
	<CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com>
	<51CC72A4.4040508@jungers.net>
	<CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com>
	<51D233A5.504@hardwarefreak.com>
	<CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com>
	<51D32DBB.8030401@hardwarefreak.com>
	<CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com>
	<51D38354.6090001@hardwarefreak.com>
	<CAPSPcXjn4=mxMLtu=88Fm9kFvh6_ujLwrTvQeqQuef3BG_c26Q@mail.gmail.com>
	<CAKuK5J0nYf3j_zTLCjBOKw49ADTKqJwU+fa7pVo4incW8J9RBQ@mail.gmail.com>
	<51D46010.6040109@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D46010.6040109@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I added the two non-fresh drives back to the array and they have been
resyncing.  The first one is almost complete.  No errors so far.
Everything is been very smooth since replacing the power supply.
And I am paying extra close attention to make sure my TLER capable
drives have it turned on, and the others have the driver timeout set
to 180.  From now on I will only be buying TLER capable drives.
Just an update.

Also, this is likely the same drive making the same noise with the top
off https://www.youtube.com/watch?v=a9i5yixsJbk
I wonder if its PWM driving the actuator against the barrier.
