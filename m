From: "Stefan Majer" <stefan@x-cellent.com>
Subject: host based mirror distance in a fc-based SAN environment
Date: Wed, 26 Jul 2006 07:58:09 +0200 (CEST)
Message-ID: <45063.212.34.68.17.1153893489.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

im curious if there are some numbers out up to which distance its possible
to mirror (raid1) 2 FC-LUNs. We have 2 datacenters with a effective
distance of 11km. The fabrics in one datacenter are connected to the
fabrics in the other datacenter with 5 dark fibre both about 11km in
distance.

I want to set up servers wich mirrors their LUNs across the SAN-boxen in
both datacenters. On top of this mirrored LUN i put lvm2.

So the question is does anybody have some numbers up to which distance
this method works ?

greetings

Stefan Majer

