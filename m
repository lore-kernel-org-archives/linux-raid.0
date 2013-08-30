From: Veedar Hokstadt <veedar@gmail.com>
Subject: Is a raid0 512 byte chunk size possible? Or is it just too small?
Date: Fri, 30 Aug 2013 15:32:41 -0400
Message-ID: <CANb3qHcczcKrCOPWy7MfY2aP_0V2c5KkQa6zzm5f1J7Qx20W8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I would like to use mdadm to set up a raid0 with a 512B chunk size.

I ask as my purpose is to mimic a raid0 config from a Lacie NAS box
that uses a 512B chunk size.

The lowest chunk value mdadm will accpet is 4. Anything less and mdadm
gives an error "invalid chunk/rounding value"

Is there any way to create a raid0 with a 512B chunk?

Thanks,
Veedar
