From: Srinivasa S <srinivasa.s@gmail.com>
Subject: raid5 xor help
Date: Fri, 15 Oct 2004 09:56:24 +0530
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8f8a51940410142126557f5198@mail.gmail.com>
Reply-To: Srinivasa S <srinivasa.s@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I was going thru the raid5 code in the linux software raid. I could
not figure out the parity computation. The mothod 'compute_parity' is
somehow calling functions like 'do_2' , 'do_3' , etc - but I could not
find their defnitions anywhere. Is there any documentation about the
raid implementations in linux? Could you please help me out in this
regard. Thanks.

Regards,
