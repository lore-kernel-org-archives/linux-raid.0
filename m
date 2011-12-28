From: Asdo <asdo@shiftmail.org>
Subject: Re: It is safe to stop Raid being reshaped
Date: Wed, 28 Dec 2011 20:02:36 +0100
Message-ID: <4EFB67CC.7010500@shiftmail.org>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Thompson <jeremythompson82@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My opinion is: don't stop the array!
Errors are not necessarily caused by heat, probably more a controller or 
firmware issue, which will present identically if you restart the 
reshaping process.
Also, this kind of issues on my 3ware controller are harmless. You could 
better ask this to SCSI people, but there are up to 5 retries (for EACH 
scsi command) by the scsi layer after these resets happen.
Stopping the reshape is much more risky imho.
