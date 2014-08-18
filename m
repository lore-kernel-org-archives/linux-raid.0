From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Can I replace raid6 disk using dd?
Date: Mon, 18 Aug 2014 14:26:16 -0500
Message-ID: <CABY_QbV8=y_VnsYk6XC0MEZ7-Np-20PoJLsyKoZA6BzdvUMguA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had a recent disk failure in my 4x2TB raid6 and as a temporary fix I
added a 4tb drive to prevent the drive from being degraded while I
researched for a new drive.

Now that I have purchased a new drive, I am wondering if it is ok to
simply dd the first 2tb of the 4tb drive to replace the drive. I am
asking because my case/motherboard does not have another HD slot to
add the new disk
in parallel with raid6. I was thinking of shutting down the machines,
moving the 4tb memmebr and the new drive to another machine,  making
image copy (only 2tb), and putting the
2tb drive back in the original machine and rebooting. Will this work?

Ramesh
