From: Drew <drew.kay@gmail.com>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Tue, 11 Aug 2009 14:35:15 -0700
Message-ID: <c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Are there are management or performance benefits of using mdadm raid-0 over using LVM striping?

I haven't used LVM striping so take my answer with a grain of salt. In
my reading on the web about the two I came to the conclusion that MD's
raid-0 code is a bit better tested then LVM's. For that reason, and
because I believe in one tool for each job, I went with MD to handle
the RAID.

> Im thinking along the lines of "LVM might be a better choice because I can have my striping (by adding another disk to the LV) and also have the added bonus of it being more 'manageable' than raid, because I can grow or shrink the LV".

If you run LVM on top of raid you can have both. :-) All my servers
run this config and it makes things easy to move around as needed, in
fact a couple of times it saved my data (and my bacon). And with newer
versions of mdadm, you can create some interesting raid configs that
LVM has no chance of creating.

So why striping? Aside from faster speeds, raid-0 is anything but redundant.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
