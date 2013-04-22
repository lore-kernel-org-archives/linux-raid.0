From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 18:21:24 -0500
Message-ID: <5175C5F4.6060304@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com> <51725458.7020109@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com> <51732422.1050109@redhost.ro> <5173536C.2040108@hardwarefreak.com> <CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com> <51743F14.7020404@hardwarefreak.com> <CAGA4a+Fsrum9vrtWbeKP4jWfT3JAAMK4Ci1HU6A2cMez1mwttw@mail.gmail.com> <517488B7.9030505@hardwarefreak.com> <CAGA4a+HS1EkQ0N1J0He25sWYeL6dhACO=zkVB6jSevZUUuOFBQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+HS1EkQ0N1J0He25sWYeL6dhACO=zkVB6jSevZUUuOFBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/22/2013 2:51 AM, Tommy Apel wrote:
> Stan>
> That was exactly what I was trying to show, that you result may vary
> depending on data and backing device, as far as the raid1 goes it
> doesn't care much for the data beeing passed through it.

As I mentioned, this is true of the SandForce 2nd gen ASICs, maybe some
others.  The Samsung SSDs use a home grown Samsung controller which
doesn't do compression.  Its performance doesn't vary due to data
content.  Thus the performance gap you demonstrated doesn't apply to Andrei.

We can eliminate this as a possible cause of his apparently horrible
performance.  And I think we can eliminate the regression in 2.6.32 as
that patch seems to be included in his kernel, otherwise he'd likely not
get 260MB/s in his dd raw read tests.  The mystery continues...

-- 
Stan



